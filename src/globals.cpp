#include "main.h"
#include <cstdint>

int8_t DTL1Port = 1; // 1st Mortor on the left drive train port
int8_t DTL2Port = 2; // 2nd Mortor on the left drive train port
int8_t DTL3Port = 3; // 3rd Mortor on the left drive train port

int8_t DTR1Port = 4; // 1st Mortor on the right drive train port
int8_t DTR2Port = 5; // 2nd Mortor on the right drive train port
int8_t DTR3Port = 6; // 3rd Mortor on the right drive train port

int intakePort  = 7; // Motor wiich controls the intake port
int outakePort  = 8; // Motor wiich controls the outake port

pros::Motor DTL1(DTL1Port, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::Motor DTL2(DTL2Port, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::Motor DTL3(DTL3Port, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::MotorGroup left_DT({DTL1Port, DTL2Port, DTL3Port}); 

pros::Motor DTR1(DTR1Port, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::Motor DTR2(DTR2Port, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::Motor DTR3(DTR3Port, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::MotorGroup right_DT({DTR1Port, DTR2Port, DTR3Port}); 

pros::Motor intake(intakePort, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);
pros::Motor outake(outakePort, pros::v5::MotorGears::blue, pros::v5::MotorUnits::degrees);

pros::Controller master(pros::E_CONTROLLER_MASTER);
