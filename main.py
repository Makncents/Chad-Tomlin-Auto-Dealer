from rag_engine import rag_query

print("💰 WELCOME TO YOUR WEALTH GENERATION AI 💰")
print("This AI has FULL ACCESS to your data and can EXECUTE REAL-WORLD TASKS.")
print("Type 'exit' to quit.\n")

while True:
    user_input = input("\n👉 Your Command: ")
    if user_input.lower() == "exit":
        break

    response = rag_query(user_input)
    print(f"\n🤖 AI: {response}")
