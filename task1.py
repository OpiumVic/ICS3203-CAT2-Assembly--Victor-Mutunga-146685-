# Task 1: Control Flow and Conditional Logic

def classify_number():
    try:
        # Prompt user for input
        number = float(input("Enter a number: "))
        
        # Conditional logic to classify the number
        if number > 0:
            print("POSITIVE")
        elif number < 0:
            print("NEGATIVE")
        else:
            print("ZERO")
    except ValueError:
        print("Invalid input! Please enter a valid number.")

# Run the function
classify_number()
