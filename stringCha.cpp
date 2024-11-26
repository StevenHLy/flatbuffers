#include "RadarActionControlMsgBody.hpp"
#include <sstream>
#include <iostream>
#include <cctype>

// Constructor
RadarActionControlMsgBody::RadarActionControlMsgBody() : command("") {}

// Set and parse the command string
void RadarActionControlMsgBody::setCommand(const std::string& command) {
    this->command = command;
    commandArguments.clear();

    // Split the command and parse each argument
    for (const auto& token : splitCommand(command, ';')) {
        commandArguments.push_back(parseArgument(token));
    }
}

// Get the parsed command arguments
const std::vector<CommandArgument>& RadarActionControlMsgBody::getCommandArguments() const {
    return commandArguments;
}

// Print the command arguments
void RadarActionControlMsgBody::printCommandArguments() const {
    std::cout << "Command Arguments:" << std::endl;
    for (const auto& arg : commandArguments) {
        std::visit([](const auto& value) {
            std::cout << "- " << value << std::endl;
        }, arg);
    }
}

// Helper function to split the command string
std::vector<std::string> RadarActionControlMsgBody::splitCommand(const std::string& command, char delimiter) const {
    std::vector<std::string> tokens;
    std::istringstream stream(command);
    std::string token;

    while (std::getline(stream, token, delimiter)) {
        // Trim leading and trailing spaces
        size_t start = token.find_first_not_of(" ");
        size_t end = token.find_last_not_of(" ");
        if (start != std::string::npos && end != std::string::npos) {
            token = token.substr(start, end - start + 1);
        }
        tokens.push_back(token);
    }
    return tokens;
}

// Helper function to parse an argument
CommandArgument RadarActionControlMsgBody::parseArgument(const std::string& token) const {
    // Check if the token is an integer
    if (!token.empty() && std::all_of(token.begin(), token.end(), ::isdigit)) {
        return std::stoi(token);
    }
    // Otherwise, treat it as a string
    return token;
}
