#ifndef RADAR_ACTION_CONTROL_MSG_BODY_HPP
#define RADAR_ACTION_CONTROL_MSG_BODY_HPP

#include <string>
#include <vector>
#include <variant>

// Variant type to store mixed data types
using CommandArgument = std::variant<int, std::string>;

class RadarActionControlMsgBody {
public:
    // Constructor
    RadarActionControlMsgBody();

    // Set and parse the command string
    void setCommand(const std::string& command);

    // Get the parsed command arguments
    const std::vector<CommandArgument>& getCommandArguments() const;

    // Print the command arguments
    void printCommandArguments() const;

private:
    // Original command string
    std::string command;

    // Parsed command arguments
    std::vector<CommandArgument> commandArguments;

    // Helper functions
    std::vector<std::string> splitCommand(const std::string& command, char delimiter) const;
    CommandArgument parseArgument(const std::string& token) const;
};

#endif // RADAR_ACTION_CONTROL_MSG_BODY_HPP
