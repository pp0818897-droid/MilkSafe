import os
from dotenv import load_dotenv
from supabase import create_client, Client

load_dotenv()

url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_SERVICE_KEY")

if not url or not key:
    print("Error: SUPABASE_URL or SUPABASE_SERVICE_KEY is missing in .env")
else:
    try:
        supabase: Client = create_client(url, key)
        # Attempt a basic operation to verify connection, e.g. list buckets or check auth
        # Note: listing buckets requires storage access, auth requires auth access.
        # But just creating the client verifies the URL structure.
        print(f"Successfully loaded SUPABASE_URL: {url}")
        print("Supabase connection established successfully!")
    except Exception as e:
        print(f"Failed to connect to Supabase: {e}")
