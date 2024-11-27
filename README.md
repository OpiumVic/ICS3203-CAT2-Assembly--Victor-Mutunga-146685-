# ICS3203-CAT2-Assembly--Victor-Mutunga-146685-
## Overview
This assignment consists of four tasks aimed at implementing basic control and monitoring systems using assembly language. Each task focuses on simulating various real-world applications such as factorial calculation, control programs based on sensor values, and manipulating memory locations and ports to simulate hardware control. The tasks demonstrate fundamental concepts of low-level programming, memory management, and system calls.

### Table of Contents
Task 1: Factorial Calculation

Task 2: Sensor Monitoring and Control

Task 3: Control Program with Motor and Alarm

Task 4: Data Monitoring and Control Using Port-Based Simulation

## Task 1: Factorial Calculation
Problem:
Write an assembly program that calculates the factorial of a given number using recursion. The input number is provided by the user, and the program outputs the result of the factorial.

### Steps:
The program prompts the user to enter a number.
It then calculates the factorial using a recursive approach.
The result is then printed to the screen.
Key Concepts:
System calls for input and output.
Stack operations for recursion.
Memory management in assembly.

### Documentation
This assembly program uses both conditional jumps (e.g., je, jne, jl) and unconditional jumps (jmp) to implement control flow. Below is the rationale for each type of jump:

#### Conditional Jumps:

je check_sign: Checks if the ASCII character being read is a newline (0x0A). This ensures input processing stops at the correct point.

je is_negative_input: Redirects to handling a negative sign if detected during input conversion.

cmp eax, 0 and je is_zero: After evaluating the number, if it is zero, the program jumps to is_zero.

cmp eax, 0 and jl is_negative: Redirects to is_negative if the number is less than zero.

These jumps provide selective branching based on conditions, allowing classification logic.

#### Unconditional Jumps:

jmp convert_to_integer: Loops back to continue processing input until a newline character is encountered.

jmp is_positive: Ensures we move directly to the positive case after determining the number is positive.

jmp exit: Terminates the program immediately after printing the appropriate classification (POSITIVE, NEGATIVE, or ZERO).

These jumps streamline flow by skipping unnecessary checks or processes once the classification is made.

## Task 2: Sensor Monitoring and Control
Problem:
Simulate a sensor monitoring system that reads input values, checks against predefined thresholds, and performs actions like turning on/off a motor or triggering an alarm.

### Steps:
The program prompts the user to enter a sensor value (representing water level).
Based on the input value:
If the value exceeds a high threshold, an alarm is triggered.
If the value is below a low threshold, a motor is turned on.
If the value falls between the thresholds, the motor is turned off.
The program manipulates specific memory locations to track motor and alarm status and prints corresponding messages.
Key Concepts:
Threshold checking based on input values.
Conditional operations for controlling hardware (simulated by memory locations).
Using memory locations to store and update status (motor and alarm).

### Documentation
#### In-Place Reversal:

Uses two pointers (ebx and ecx) to represent the left and right ends of the array.
Elements at these indices are swapped without using additional memory.

#### Looping Logic:

The loop continues until the left pointer (ebx) meets or exceeds the right pointer (ecx), ensuring all swaps are performed.
Challenges Addressed:

#### Memory Handling:
Avoids creating new arrays by working directly on the original array using indexed addressing.
Byte-Sized Operations: Since the array is defined as db (bytes), the code handles byte-sized data with mov and registers like al and dl.

#### Debugging Output:

The reversed array is printed as a sequence of numbers separated by spaces. Modify this part as needed for actual debugging or display purposes.

## Task 3: Control Program with Motor and Alarm
Problem:
Write an assembly program that simulates controlling a motor and alarm system based on sensor input. The program should:

Turn on the motor if the sensor value is below a low threshold.
Trigger the alarm if the sensor value exceeds a high threshold.
Stop the motor if the sensor value is moderate.

### Steps:
The program prompts the user to enter a sensor value.
The sensor value is compared to predefined thresholds.
Based on the value:
If it exceeds the high threshold, the alarm is triggered.
If it is below the low threshold, the motor is turned on.
If it is between the thresholds, the motor is turned off.
Key Concepts:
Memory manipulation for tracking motor and alarm status.
Using system calls for input/output operations.
Handling conditional logic based on input values to control hardware simulations.

### Documentation
Explanation of how registers are managed, particularly how values are preserved and restored in the stack.:

#### Input Handling:
The input is now processed correctly. The program reads a string from the user, converts the first character to an integer by subtracting the ASCII value of '0', and stores it in ebx.

#### Factorial Subroutine:

The factorial calculation is implemented recursively.
We check if ebx <= 1 (the base case) and return 1.
If not, we store ebx on the stack, decrement it, and call the factorial subroutine recursively. After the recursive call, we restore ebx and multiply eax (the result) by ebx.

#### Register Preservation:
The registers ebx and eax are carefully preserved and restored using the stack during the recursive factorial calculation. This ensures that the calculation proceeds without corrupting the values of registers.

#### Printing the Result:

The print_integer subroutine converts the integer in eax to ASCII characters and prints it character by character using a loop.
The result is printed after the factorial calculation.

## Task 4: Data Monitoring and Control Using Port-Based Simulation
Problem:
Simulate a control program that reads a “sensor value” from a specified memory location or input port, and based on the input, performs actions such as:

Turning on a motor.
Triggering an alarm if the sensor value exceeds a predefined high threshold.
Stopping the motor if the sensor value is moderate.

### Steps:
The program prompts the user to enter a sensor value.
Based on the value:
If the value exceeds the high threshold, trigger the alarm.
If the value is below the low threshold, turn on the motor.
If the value is between the thresholds, stop the motor.
The program manipulates specific memory locations (simulating ports) to track the status of the motor and alarm.
Key Concepts:
Sensor value input and conversion.
Comparing sensor values against threshold values to make decisions.
Memory manipulation to control motor and alarm status.

### Documentation
#### User Input:
The sensor value is input as an ASCII character, which is converted into an integer and stored.
#### Threshold Checking:
The program checks the sensor value against predefined thresholds and takes appropriate actions.
#### Memory Locations:
The memory locations sensor_value, motor_status, and alarm_status store the sensor reading, motor state, and alarm state, respectively.
System Calls: The program uses Linux system calls (int 0x80) for reading input, printing output, and exiting the program.

### Assembly Code Structure
Each task contains assembly code structured into different sections:

.data: Contains all the static data used by the program, including strings for messages and predefined values for thresholds, motor status, and alarm status.
.bss: Contains uninitialized variables (buffers) to store user input.
.text: Contains the main program logic, including system calls for input and output, calculations, and condition handling.
Key System Calls:
int 0x80: Used for system calls in Linux assembly. The program uses this for write, read, and exit system calls.
mov: Moves data between registers or between registers and memory.
cmp and j: Used for conditional checks and jumps based on comparisons.
Compilation and Execution
To compile and run each program, follow these steps:

Assemble the Code:


nasm -f elf32 <task_name>.asm -o <task_name>.o
Link the Object File:


gcc -m32 -nostartfiles -o  <task_name>.o -o <task_name>
Run the Program:


./<task_name>
Ensure that you have the appropriate permissions to execute the compiled program. You can modify the program inputs and thresholds as needed by editing the assembly code.

### Conclusion
This assignment demonstrates basic assembly programming techniques for controlling systems based on input values. It covers concepts like recursion, memory manipulation, sensor-based decision making, and simulating control systems such as motors and alarms using assembly language. The exercises also highlight how low-level programming can be used to interact with hardware or simulate hardware behavior.
