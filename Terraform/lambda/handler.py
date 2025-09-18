import json
import boto3
import os
import uuid

polly = boto3.client("polly")
s3 = boto3.client("s3")

BUCKET_NAME = os.environ.get("BUCKET_NAME", "ab3-text-to-speech-tf")

def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))
        text = body.get("text", "")
        voice = body.get("voice", "Joanna")

        if not text:
            return _response(400, {"error": "No text provided"})

        # Generate audio with Polly
        response = polly.synthesize_speech(
            Text=text,
            OutputFormat="mp3",
            VoiceId=voice
        )

        audio_key = f"audio/{uuid.uuid4()}.mp3"
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=audio_key,
            Body=response["AudioStream"].read(),
            ContentType="audio/mpeg"
        )

        # Build file URL
        public_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{audio_key}"

        return _response(200, {"public_url": public_url})

    except Exception as e:
        return _response(500, {"error": str(e)})


def _response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST"
        },
        "body": json.dumps(body)
    }
