import json

def main():
  source_file = "./organizations.json"
  with open(source_file, 'r') as f:
    file_contents = json.load(f)
  entries = file_contents['entry']
  bundle = without_keys(file_contents, "entry") 
  processed_entries = process_entries(entries)
  bundle['entry'] = processed_entries
  print(json.dumps(bundle))


def process_entries(entries: list) -> list:
  processed = []
  for entry in entries:
    if entry['resource']['resourceType'] == "Organization":
      mentry = process_org(entry)
    elif entry['resource']['resourceType'] == "Location":
      mentry = process_location(entry)
    else:
      mentry = entry
      logging.warn(f"Nothing processed for {entry['resource']['resourceType']}")
    processed.append(mentry)

  return processed

def process_location(entry):
  entry['resource']['position']['longitude'] = float(entry['resource']['position']['longitude'])
  entry['resource']['position']['latitude'] = float(entry['resource']['position']['latitude'])

  if type(entry['resource']['address']) is list:
    entry['resource']['address'] = entry['resource']['address'][0]
    
  return entry

def process_org(entry):
  return entry

def correct_location_positions(location: dict):
  pass

def without_keys(d, keys):
  return {x: d[x] for x in d if x not in keys}

def string_to_number():
  pass


if __name__ == "__main__":
  main()
