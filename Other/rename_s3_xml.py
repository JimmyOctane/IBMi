#!/usr/bin/env python3
"""
Rename .xml files to .old in S3 bucket
This script is called by NEUS3RTVC.CLLE after syncing files from S3
Only renames files that exist locally in /home/neuco to ensure they were downloaded
"""
import subprocess
import sys
import os

def main():
    if len(sys.argv) < 3:
        print("Usage: rename_s3_xml.py <profile> <bucket>")
        sys.exit(1)
    
    profile = sys.argv[1]
    bucket = sys.argv[2]
    local_dir = '/home/neuco'
    
    # Get list of .xml files that exist locally (successfully downloaded)
    try:
        local_xml_files = [f for f in os.listdir(local_dir)
                          if f.endswith('.xml') and os.path.isfile(os.path.join(local_dir, f))]
    except OSError as e:
        print(f"Error reading local directory {local_dir}: {e}")
        sys.exit(1)
    
    if not local_xml_files:
        print("No .xml files found in local directory. Nothing to rename in S3.")
        sys.exit(0)
    
    print(f"Found {len(local_xml_files)} .xml files locally that were successfully downloaded")
    
    # List all .xml files in the S3 bucket
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
        
        s3_xml_files = []
        for line in lines:
            if line.strip() and line.endswith('.xml'):
                # Extract filename from AWS ls output (4th column)
                parts = line.split()
                if len(parts) >= 4:
                    filename = parts[3]
                    # Get just the basename for comparison
                    basename = os.path.basename(filename)
                    # Only add if this file exists locally (was successfully downloaded)
                    if basename in local_xml_files:
                        s3_xml_files.append(filename)
        
        print(f"Found {len(s3_xml_files)} .xml files in S3 that match local downloads")
        
        # Rename each .xml file to .old in S3
        renamed_count = 0
        for xml_file in s3_xml_files:
            old_file = xml_file.replace('.xml', '.old')
            
            mv_cmd = [
                '/home/awssvc/.local/bin/aws',
                '--profile', profile,
                's3', 'mv',
                f'{bucket}/{xml_file}',
                f'{bucket}/{old_file}'
            ]
            
            try:
                subprocess.run(mv_cmd, check=True, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, universal_newlines=True)
                print(f"Renamed in S3: {xml_file} -> {old_file}")
                renamed_count += 1
            except subprocess.CalledProcessError as e:
                print(f"Error renaming {xml_file}: {e.stderr}")
        
        print(f"Successfully renamed {renamed_count} files in S3")
        
    except subprocess.CalledProcessError as e:
        print(f"Error listing S3 files: {e.stderr}")
        sys.exit(1)

if __name__ == '__main__':
    main()
