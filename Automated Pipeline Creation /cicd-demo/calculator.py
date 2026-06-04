"""
Simple calculator module for CI/CD demonstration
"""

def add(a, b):
    """Add two numbers"""
    # TODO: Implement addition
    pass

def subtract(a, b):
    """Subtract b from a"""
    # TODO: Implement subtraction
    pass

def multiply(a, b):
    """Multiply two numbers"""
    # TODO: Implement multiplication
    pass

def divide(a, b):
    """Divide a by b"""
    # TODO: Implement division with zero check
    pass
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
