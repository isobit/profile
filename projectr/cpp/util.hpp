#pragma once
#include <iostream>
#include <string>
#include <sstream>

#define uint unsigned int

#define VARDUMP(v) util::debug(util::fmt() << #v << " = " << v, __LINE__, __FILE__)
#define DEBUG(msg) util::debug(msg, __LINE__, __FILE__)
#define WARN(msg) util::warn(msg, __LINE__, __FILE__)
#define ERROR(msg) util::error(msg, __LINE__, __FILE__)

namespace util {
	static bool DEBUG_ENABLED = true;
	static bool DEBUG_TRACE = false;
	struct fmt {
		std::stringstream ss;
		template<typename T>
		fmt & operator << (const T &data) {
			ss << data;
			return *this;
		}
		operator std::string() { return ss.str(); }
		operator const char* () { return ss.str().c_str(); }
	};
	void debug(std::string msg, const int line, const char* file) {
		if (!DEBUG_ENABLED) return;
		std::cerr << "DEBUG: " << msg;
		if (DEBUG_TRACE)
			std::cerr << " (" << file << ", " << line << ")";
		std::cerr << "\n";
	}
	void warn(std::string msg, const int line, const char* file) {
		std::cerr << "WARNING: " << msg 
			<< " (" << file << ", " << line << ")" << "\n";
	}
	void error(std::string msg, const int line, const char* file) {
		std::ostringstream ss;
		ss << msg << " (" << file << ", " << line << ")";
		throw ss.str();
	}
}
