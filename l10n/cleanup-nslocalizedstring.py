#!/usr/bin/python
#
# Clean up NSLocalizedString usage excluding files within "blacklisted_parent_directories"
# Run ./l10n/cleanup-nslocalizedstring.py from project root folder

import os
import re
import sys
import json

blacklisted_files = ["BundleExtensions.swift"]
frameworks = ["BraveRewardsUI"]

def replacement_string(key, value):
  if key in keyDict:
    duplicate[key] = value
  else:
    keyDict[key] = value
  return 'Strings.' + key

def parent_directory(path):
  norm_path = os.path.normpath(path)
  path_components = norm_path.split(os.sep)
  directory = path_components[0]
  return directory

def should_skip_file(file):
  if file in blacklisted_files:
    return True
  return False

def should_skip_path(path):
  directory = parent_directory(path)
  if directory in frameworks:
    return True
  return False

keyDict = {}
duplicate = {}

for path, directories, files in os.walk("."):
  for file in files:
    if should_skip_file(file) || should_skip_path(path):
      continue

    if file.endswith(".swift"):
      quoted_string_pattern = r' *\"([^\"\\]*(?:(?:\\\.|\"\"|\\\")[^\"\\]*)*)\" *'
      # This is not matching in some cases, ignoring for now.
      pattern = 'BATLocalizedString\(' + quoted_string_pattern + ', ' + quoted_string_pattern + '\)'
      directory = parent_directory(path)
      if directory in frameworks:
        table_name = directory
      	print "Processing " + path + "/" + file + " [Framework: " + directory + "]"
      else:
        print "Processing " + path + "/" + file

      flags = re.MULTILINE | re.DOTALL
      
      
      with open(os.path.join(path, file), 'r') as source:
        content = source.read()
        replacement_pattern = lambda match: replacement_string(match.group(1), match.group(2))
        content = re.sub(pattern, replacement_pattern, content, flags = flags)
        
        with open(os.path.join(path, file), 'w') as source:
          source.write(content)

with open("./Localized Strings/Strings.swift", 'a+') as source:
    
    ##     if the file is created first time add the license and declare Strings struct
    source.write('public extension Strings {\n')
    for key, value in keyDict.iteritems():
      source.write('  static let ' +  key + ' = NSLocalizedString("' + key + '", bundle: Bundle.RewardsUI, value: "' + value + '", comment: "")\n')
    source.write('}\n\n')

# This adds the duplicate Keys in the Strings file for manual removal.
    source.write('public extension Strings {\n')
    for key, value in duplicate.iteritems():
        source.write('  static let ' +  key + ' = NSLocalizedString("' + key + '", bundle: Bundle.RewardsUI, value: "' + value + '", comment: "")\n')
    source.write('}')


print keyDict
print '\n\n'
print duplicate
