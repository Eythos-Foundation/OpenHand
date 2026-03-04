/**
 * Credential encryption utilities for OpenHand
 * Provides at-rest encryption for sensitive data using AES-256-GCM
 */

import * as crypto from "node:crypto";

const ALGORITHM = "aes-256-gcm";
const IV_LENGTH = 16;
const SALT_LENGTH = 32;
const KEY_LENGTH = 32;
const ITERATIONS = 100000;

export interface EncryptedData {
  iv: string;
  authTag: string;
  encrypted: string;
  salt: string;
}

/**
 * Derives an encryption key from a password using PBKDF2
 */
function deriveKey(password: string, salt: Buffer): Buffer {
  return crypto.pbkdf2Sync(password, salt, ITERATIONS, KEY_LENGTH, "sha512");
}

/**
 * Encrypts sensitive data using AES-256-GCM
 * @param plaintext - The data to encrypt
 * @param password - The master password to derive the encryption key
 * @returns Encrypted data with IV, auth tag, and salt
 */
export function encryptCredential(plaintext: string, password: string): EncryptedData {
  const salt = crypto.randomBytes(SALT_LENGTH);
  const key = deriveKey(password, salt);
  const iv = crypto.randomBytes(IV_LENGTH);

  const cipher = crypto.createCipheriv(ALGORITHM, key, iv);

  let encrypted = cipher.update(plaintext, "utf8", "hex");
  encrypted += cipher.final("hex");

  const authTag = cipher.getAuthTag();

  return {
    iv: iv.toString("hex"),
    authTag: authTag.toString("hex"),
    encrypted,
    salt: salt.toString("hex"),
  };
}

/**
 * Decrypts data that was encrypted with encryptCredential
 * @param data - The encrypted data object
 * @param password - The master password used for encryption
 * @returns The decrypted plaintext
 */
export function decryptCredential(data: EncryptedData, password: string): string {
  const salt = Buffer.from(data.salt, "hex");
  const key = deriveKey(password, salt);
  const iv = Buffer.from(data.iv, "hex");
  const authTag = Buffer.from(data.authTag, "hex");

  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(authTag);

  let decrypted = decipher.update(data.encrypted, "hex", "utf8");
  decrypted += decipher.final("utf8");

  return decrypted;
}

/**
 * Checks if a string looks like encrypted data
 */
export function isEncryptedData(data: unknown): data is EncryptedData {
  if (typeof data !== "object" || data === null) {
    return false;
  }

  const obj = data as Record<string, unknown>;
  return (
    typeof obj.iv === "string" &&
    typeof obj.authTag === "string" &&
    typeof obj.encrypted === "string" &&
    typeof obj.salt === "string"
  );
}

/**
 * Generates a secure random password for use as a master key
 */
export function generateMasterPassword(length: number = 32): string {
  return crypto.randomBytes(length).toString("base64").slice(0, length);
}
