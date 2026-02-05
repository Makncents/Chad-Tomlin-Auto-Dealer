import time

from rag_engine import rag_query
from task_executor import execute_task


def monitor_market():
    while True:
        # Check market conditions every 30 minutes
        time.sleep(1800)

        # Ask AI for trading decisions
        decision = rag_query(
            "Based on my portfolio and live market data, what trade should I execute NOW to maximize returns?"
        )

        print(f"[AUTO-TRADER] Decision: {decision}")

        # Execute if the decision includes a trade
        if "buy" in decision.lower() or "sell" in decision.lower():
            result = execute_task(decision)
            print(f"[AUTO-TRADER] Executed: {result}")


if __name__ == "__main__":
    monitor_market()
