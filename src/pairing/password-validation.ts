/**
 * Password validation utilities for OpenHand
 * Ensures passwords meet minimum security requirements
 */

export interface PasswordValidationResult {
  valid: boolean;
  errors: string[];
  suggestions: string[];
}

const MIN_PASSWORD_LENGTH = 12;
const MAX_PASSWORD_LENGTH = 128;

export function validatePassword(password: string): PasswordValidationResult {
  const errors: string[] = [];
  const suggestions: string[] = [];

  if (!password) {
    return {
      valid: false,
      errors: ["Password cannot be empty"],
      suggestions: ["Create a strong password with at least 12 characters"],
    };
  }

  // Check length
  if (password.length < MIN_PASSWORD_LENGTH) {
    errors.push(`Password must be at least ${MIN_PASSWORD_LENGTH} characters`);
    suggestions.push(`Add ${MIN_PASSWORD_LENGTH - password.length} more characters`);
  }

  if (password.length > MAX_PASSWORD_LENGTH) {
    errors.push(`Password must be less than ${MAX_PASSWORD_LENGTH} characters`);
  }

  // Check for uppercase
  if (!/[A-Z]/.test(password)) {
    errors.push("Password must contain at least one uppercase letter");
    suggestions.push("Add an uppercase letter (A-Z)");
  }

  // Check for lowercase
  if (!/[a-z]/.test(password)) {
    errors.push("Password must contain at least one lowercase letter");
    suggestions.push("Add a lowercase letter (a-z)");
  }

  // Check for numbers
  if (!/[0-9]/.test(password)) {
    errors.push("Password must contain at least one number");
    suggestions.push("Add a number (0-9)");
  }

  // Check for special characters
  if (!/[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/.test(password)) {
    errors.push("Password must contain at least one special character");
    suggestions.push("Add a special character (!@#$%^&*...)");
  }

  // Check for common weak passwords
  const commonPasswords = [
    "password",
    "123456",
    "qwerty",
    "admin",
    "letmein",
    "welcome",
    "monkey",
    "dragon",
    "master",
    "login",
  ];

  if (commonPasswords.some((common) => password.toLowerCase().includes(common))) {
    errors.push("Password contains common words that are easy to guess");
    suggestions.push("Avoid common words like 'password', 'admin', etc.");
  }

  return {
    valid: errors.length === 0,
    errors,
    suggestions,
  };
}

export function getPasswordStrengthLabel(password: string): string {
  const result = validatePassword(password);

  if (password.length >= 16 && result.valid) {
    return "Strong";
  }
  if (password.length >= 12 && /[A-Z]/.test(password) && /[0-9]/.test(password)) {
    return "Good";
  }
  if (password.length >= 8) {
    return "Fair";
  }
  return "Weak";
}

export function generatePasswordSuggestion(): string {
  const uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const lowercase = "abcdefghijklmnopqrstuvwxyz";
  const numbers = "0123456789";
  const symbols = "!@#$%^&*";

  const getRandom = (str: string) => str[Math.floor(Math.random() * str.length)];

  let password = "";
  password += getRandom(uppercase);
  password += getRandom(uppercase);
  password += getRandom(lowercase);
  password += getRandom(lowercase);
  password += getRandom(numbers);
  password += getRandom(numbers);
  password += getRandom(symbols);
  password += getRandom(symbols);

  // Add 8 more random characters
  const all = uppercase + lowercase + numbers + symbols;
  for (let i = 0; i < 8; i++) {
    password += getRandom(all);
  }

  // Shuffle the password (using sort instead of toSorted for compatibility)
  return password
    .split("")
    .toSorted(() => Math.random() - 0.5)
    .join("");
}
