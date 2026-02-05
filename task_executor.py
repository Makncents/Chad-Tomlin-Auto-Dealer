import requests
from bs4 import BeautifulSoup
import smtplib


def execute_task(task_instruction):
    """Parse instructions & execute real-world tasks."""

    if "buy stock" in task_instruction.lower():
        # Example: "Buy 10 shares of AAPL at market price"
        symbol = task_instruction.split("of")[1].split()[0].strip()
        quantity = task_instruction.split()[1]
        return trade_stock(symbol, quantity)

    elif "scrape deals" in task_instruction.lower():
        return scrape_startup_deals()

    elif "send email" in task_instruction.lower():
        recipient = task_instruction.split("to")[1].split()[0].strip()
        subject = "Action Required"
        body = task_instruction.split("body:")[1].strip()
        return send_email(recipient, subject, body)

    else:
        return "Task not supported. Add new functions to task_executor.py!"


# ---- REAL-WORLD TASK FUNCTIONS ----
def trade_stock(symbol, quantity):
    """Connect to your brokerage API (e.g., Alpaca, Interactive Brokers)"""
    # Replace with YOUR brokerage API
    headers = {"APCA-API-KEY-ID": "YOUR_ALPACA_KEY"}
    url = f"https://paper-api.alpaca.markets/v2/orders"
    payload = {
        "symbol": symbol,
        "qty": quantity,
        "side": "buy",
        "type": "market",
    }
    response = requests.post(url, json=payload, headers=headers)
    return f"Order placed! Status: {response.status_code}"


def scrape_startup_deals():
    """Scrape startup funding deals from Crunchbase"""
    url = "https://www.crunchbase.com/search/funding_rounds"
    response = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
    soup = BeautifulSoup(response.text, "html.parser")
    deals = [deal.text for deal in soup.select(".identifier-label")[:5]]
    return f"Top 5 Recent Deals:\n" + "\n".join(deals)


def send_email(to, subject, body):
    """Send email via SMTP"""
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login("your_email@gmail.com", "your_app_password")
        msg = f"Subject: {subject}\n\n{body}"
        server.sendmail("your_email@gmail.com", to, msg)
    return f"Email sent to {to}!"
