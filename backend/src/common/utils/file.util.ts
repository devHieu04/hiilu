import { unlink } from 'fs/promises';
import { existsSync } from 'fs';
import { join } from 'path';

export class FileUtil {
  /**
   * Generate file URL from filename
   */
  static generateFileUrl(filename: string | undefined, baseUrl: string): string | undefined {
    if (!filename) return undefined;
    return `${baseUrl}/uploads/${filename}`;
  }

  /**
   * Delete file from filesystem
   */
  static async deleteFile(filepath: string): Promise<void> {
    try {
      const fullPath = join(process.cwd(), filepath);
      if (existsSync(fullPath)) {
        await unlink(fullPath);
      }
    } catch (error) {
      console.error(`Error deleting file ${filepath}:`, error);
    }
  }

  /**
   * Extract filename from file path
   */
  static getFilenameFromPath(filepath: string | undefined): string | undefined {
    if (!filepath) return undefined;
    return filepath.split('/').pop();
  }

  /**
   * Get file path from filename
   */
  static getFilePathFromFilename(filename: string, type: 'avatar' | 'cover'): string {
    return `uploads/${type}s/${filename}`;
  }
}
