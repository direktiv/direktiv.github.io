# Scripting 
 [Scripting on Github](https://github.com/direktiv/direktiv-examples/tree/main/scripting)

To use scripts like Python, Javascript, Powershell etc. A script can be loaded from flow or namespace variables. These files can be provided to the actions and executed. If the namespace is synced via Git a naming convention adds variables to worklflows. If a file has a prefix of a flow it will be added as variable. This enables Direktiv to use it as script in a flow, e.g.:

- myflow.yaml
- myflow.yaml.script.sh

In the above example there would be a `script.sh` flow variable. The following flow example uses Python but any file type can be used, even binaries.


```yaml title="Python Flow"
functions:
- id: python
  image: direktiv/python:dev
  type: knative-workflow
states:
- id: python
  type: action
  action:
    function: python
    # use AWS key and secret
    secrets: ["AWS_ACCESS_KEY_ID","AWS_SECRET_ACCESS_KEY"]
    files:
    - key: python.py
      scope: workflow
    input: 
      commands:
      - command: pip install boto3
      - command: python3 python.py
        envs: 
        - name: AWS_ACCESS_KEY_ID
          value: jq(.secrets.AWS_ACCESS_KEY_ID)
        - name: AWS_SECRET_ACCESS_KEY
          value: jq(.secrets.AWS_SECRET_ACCESS_KEY)
      - command: cat out.json
  transform:
    regions: jq(.return.python[1].result)

        
```



```python title="python.py"
import boto3
import os
import json

session = boto3.session.Session()

regions = {}

client = boto3.client('ec2',region_name='us-east-1')
ec2_regions = [region['RegionName'] for region in client.describe_regions()['Regions']]
for region in ec2_regions:
    print("executing region " + region)
    vs = []
    ec2_resource = session.resource('ec2', region_name=region)
    for volume in ec2_resource.volumes.filter():
        if volume.state == 'available':
            vs.append(volume.id)
    
    if len(vs) > 0:
        regions[region] = vs
        print("added " + str(len(vs)) +  "volumes for region  " + region)

# writes json to a file
with open('out.json', 'w') as out_file:
     json.dump(regions, out_file)

# writes json to a workflow variable
with open('out/workflow/out.json', 'w') as out_file:
     json.dump(regions, out_file)
```