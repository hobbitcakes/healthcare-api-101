import json
import requests

def main():
  # Get the pub/sub subscription name.
  subscription_name = os.environ['fhir_subscription']
  fhir_prefix = os.environ('fhir_prefix')

  # Create a pub/sub client.
  client = pubsub.Client()

  # Create a subscription.
  subscription = client.subscription(subscription_name)

  # Listen for messages on the subscription.
  for message in subscription.listen():
    # Get the data from the message.
    data = json.loads(message.data)

    # Call the API.
    requests.get(f'{fhir_prefix}/{data, data=data)

    # Acknowledge the message.
    message.ack()

if __name__ == '__main__':
  main()
