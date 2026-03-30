#!/usr/bin/env python3
"""
Restore .old files back to .xml in S3 bucket for testing
This script renames .old files back to .xml so you can retest the rename_s3_xml.py script
"""
import subprocess
import sys
import os

def main():
    if len(sys.argv) < 3:
        print("Usage: restore_s3_xml.py <profile> <bucket>")
        print("Example: restore_s3_xml.py Neuco_development s3://ec-neuco-stg-sftp")
        sys.exit(1)
    
    profile = sys.argv[1]
    bucket = sys.argv[2]
    
    print(f"Restoring .old files to .xml in bucket: {bucket}")
    print(f"Using profile: {profile}")
    
    # List all .old files in the S3 bucket
    cmd = [
        '/home/awssvc/.local/bin/aws',
        '--profile', profile,
        's3', 'ls',
        bucket,
        '--recursive'
    ]
    
    try:
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                              universal_newlines=True, check=True)
        lines = result.stdout.strip().split('\n')
        
        old_files = []
        for line in lines:
            if line.strip() and line.endswith('.old'):
                # Extract filename from AWS ls output (4th column)
                parts = line.split()
                if len(parts) >= 4:
                    filename = parts[3]
                    old_files.append(filename)
        
        if not old_files:
            print("No .old files found in S3 bucket. Nothing to restore.")
            sys.exit(0)
        
        print(f"Found {len(old_files)} .old files to restore to .xml")
        
        # Rename each .old file back to .xml
        restored_count = 0
        for old_file in old_files:
            xml_file = old_file.replace('.old', '.xml')
            
            mv_cmd = [
                '/home/awssvc/.local/bin/aws',
                '--profile', profile,
                's3', 'mv',
                f'{bucket}/{old_file}',
                f'{bucket}/{xml_file}'
            ]
            
            try:
                subprocess.run(mv_cmd, check=True, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, universal_newlines=True)
                print(f"Restored: {old_file} -> {xml_file}")
                restored_count += 1
            except subprocess.CalledProcessError as e:
                print(f"Error restoring {old_file}: {e.stderr}")
        
        print(f"\nSuccessfully restored {restored_count} files to .xml")
        print(f"You can now retest the rename_s3_xml.py script")
        
    except subprocess.CalledProcessError as e:
        print(f"Error listing S3 files: {e.stderr}")
        sys.exit(1)

if __name__ == '__main__':
    main()
