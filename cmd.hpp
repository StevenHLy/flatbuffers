#ifndef RADAR_ACTION_CONTROL_MSG_BODY_HPP
#define RADAR_ACTION_CONTROL_MSG_BODY_HPP

#include <string>
#include <vector>
#include <iostream>

class RadarActionControlMsgBody {
public:
    int type;           // 0 = Transmitter, 1 = Receiver
    int id;             // 1 = Dickie, 2 = Penzias, 3 = Wilson
    int channels;       // 0 = Horizontal, 1 = Vertical, 2 = Dual pole
    double frequency;   // Transmit/receive center frequency
    double azimuth;     // Radar position azimuth
    double elevation;   // Radar position elevation
    int mode;           // 0 = point-and-shoot, 1 = sweep, 2 = solar cal

    // Parse the command string
    void parseCommand(const std::string& command);

    // Print the parsed command
    void printCommand() const;

private:
    // Helper functions
    std::vector<std::string> split(const std::string& str, char delimiter) const;
};

#endif // RADAR_ACTION_CONTROL_MSG_BODY_HPP
