function createXHR(method, url, timeout) {
    var xhr = new XMLHttpRequest();
    if ("withCredentials" in xhr) {
        // XHR for Chrome/Firefox/Opera/Safari.
        xhr.open(method, url, true);
    } else if (typeof XDomainRequest != "undefined") {
        // XDomainRequest for IE.
        xhr = new XDomainRequest();
        xhr.open(method, url);
    } else {
        // CORS not supported.
        xhr = null;
    }
    xhr.timeout = timeout;
    return xhr;
}

class HTTPResponse {
    constructor(xhr, retryCount = 0) {
        this.retryCount = retryCount;
        this.status = xhr.status;
        this.headers = {
            get: function(name) {
                return xhr.getResponseHeader(name);
            }
        };
        var self = this;
        this.data = function() {
            let contentType = self.headers.get('Content-Type');
            if (contentType && typeof contentType === 'string' && contentType.indexOf('json') != -1)
                return JSON.parse(xhr.responseText);
            else
                return xhr.response;
        }();
        this.xhr = xhr;
    }
}

export class HTTP {
    constructor(
        interceptors = [],
        headers = {}
    ) {
        this.interceptors = interceptors;
        this.headers = headers;
        this.timeout = 5000;
    }

    request(method, url, data) {
        let self = this;
        return new Promise((resolve, reject) => {
            let retryCount = 0;
            function makeRequest() {
                let req = createXHR(method, url, self.timeout);
                Object.keys(self.headers).forEach(k => req.setRequestHeader(k, self.headers[k]));
                req.addEventListener('load', function() {
                    let resp = new HTTPResponse(this, retryCount);
                    let i = 0;
                    function getNextMiddleware() {
                        if (i < self.interceptors.length)
                            return self.interceptors[i++];
                        else
                            return () => {
                                if (resp.status == 200) {
                                    resolve(resp);
                                } else {
                                    reject(resp);
                                }
                            }
                    }
                    function callNextMiddleware() {
                        getNextMiddleware()(resp, callNextMiddleware, makeRequest)
                    }
                    callNextMiddleware();
                });
                req.addEventListener('error', function() {
                    let resp = new HTTPResponse(this, retryCount);
                    let i = 0;
                    function getNextMiddleware() {
                        if (i < self.interceptors.length)
                            return self.interceptors[i++];
                        else
                            return () => reject(resp);
                    }
                    function callNextMiddleware() {
                        getNextMiddleware()(resp, callNextMiddleware, makeRequest)
                    }
                    callNextMiddleware();
                });
                req.addEventListener('timeout', function() {
                    let resp = new HTTPResponse(this, retryCount);
                    let i = 0;
                    function getNextMiddleware() {
                        if (i < self.interceptors.length)
                            return self.interceptors[i++];
                        else
                            return () => reject(resp);
                    }
                    function callNextMiddleware() {
                        getNextMiddleware()(resp, callNextMiddleware, makeRequest)
                    }
                    callNextMiddleware();
                });
                if (data) {
                    req.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
                    req.send(JSON.stringify(data));
                } else {
                    req.send();
                }
                retryCount++;
            }
            makeRequest();
        });
    }
    get(url) {
        return this.request('GET', url);
    }
    post(url, data) {
        return this.request('POST', url, data);
    }
    put(url, data) {
        return this.request('PUT', url, data);
    }
    delete(url) {
        return this.request('DELETE', url);
    }

    addInterceptor(interceptor) {
        this.interceptors.push(interceptor);
    }
    setHeader(key, value) {
        this.headers[key] = value;
    }
}

export default new HTTP();
