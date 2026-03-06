"""
USD to CAD Exchange Rate Fetcher

This script fetches the current exchange rate between US Dollar (USD) 
and Canadian Dollar (CAD) using a free currency exchange API.
"""

import requests
import json
from datetime import datetime


def get_usd_to_cad_rate():
    """
    Fetch the current USD to CAD exchange rate using exchangerate-api.com
    
    Returns:
        dict: Dictionary containing exchange rate information
    """
    try:
        # Using exchangerate-api.com free tier (no API key required for basic usage)
        url = "https://api.exchangerate-api.com/v4/latest/USD"
        
        print("Fetching current USD to CAD exchange rate...")
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        
        # Extract CAD rate
        cad_rate = data['rates']['CAD']
        base_currency = data['base']
        last_updated = data['date']
        
        result = {
            'base_currency': base_currency,
            'target_currency': 'CAD',
            'exchange_rate': cad_rate,
            'last_updated': last_updated,
            'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }
        
        return result
        
    except requests.exceptions.RequestException as e:
        print(f"Error fetching exchange rate: {e}")
        return None
    except KeyError as e:
        print(f"Error parsing response data: {e}")
        return None


def display_exchange_rate(rate_info):
    """
    Display the exchange rate information in a formatted way
    
    Args:
        rate_info (dict): Dictionary containing exchange rate information
    """
    if rate_info:
        # Convert dates to MMDDYY format
        last_updated_mmddyy = datetime.strptime(rate_info['last_updated'], '%Y-%m-%d').strftime('%m%d%y')
        retrieved_mmddyy = datetime.strptime(rate_info['timestamp'], '%Y-%m-%d %H:%M:%S').strftime('%m%d%y')
        
        print("\n" + "="*50)
        print("USD to CAD Exchange Rate")
        print("="*50)
        print(f"1 {rate_info['base_currency']} = {rate_info['exchange_rate']:.4f} {rate_info['target_currency']}")
        print(f"Last Updated: {last_updated_mmddyy}")
        print(f"Retrieved: {retrieved_mmddyy}")
        print("="*50)
        
        # Show some conversion examples
        print("\nConversion Examples:")
        amounts = [10, 50, 100, 500, 1000]
        for amount in amounts:
            converted = amount * rate_info['exchange_rate']
            print(f"  ${amount:,} USD = ${converted:,.2f} CAD")
    else:
        print("Unable to display exchange rate information.")


def convert_usd_to_cad(usd_amount, rate_info):
    """
    Convert a specific USD amount to CAD
    
    Args:
        usd_amount (float): Amount in USD to convert
        rate_info (dict): Dictionary containing exchange rate information
        
    Returns:
        float: Converted amount in CAD
    """
    if rate_info:
        return usd_amount * rate_info['exchange_rate']
    return None


if __name__ == "__main__":
    import sys
    
    # Fetch the current exchange rate
    rate_info = get_usd_to_cad_rate()
    
    if not rate_info:
        print("ERROR: Unable to fetch exchange rate")
        sys.exit(1)
    
    # Check if amount was passed as command line argument
    if len(sys.argv) > 1:
        # Parameter mode - NO PROMPTING
        try:
            custom_amount = float(sys.argv[1])
            
            if custom_amount > 0:
                converted = convert_usd_to_cad(custom_amount, rate_info)
                # Output just the converted value for easy parsing
                print(f"USD_AMOUNT={custom_amount:.2f}")
                print(f"CAD_AMOUNT={converted:.2f}")
                print(f"EXCHANGE_RATE={rate_info['exchange_rate']:.4f}")
                print(f"LAST_UPDATED={rate_info['last_updated']}")
            else:
                print("ERROR: Amount must be greater than 0")
                sys.exit(1)
        except ValueError:
            print("ERROR: Invalid amount provided")
            sys.exit(1)
    else:
        # Interactive mode - with prompting
        display_exchange_rate(rate_info)
        
        print("\n" + "-"*50)
        try:
            custom_amount = float(input("\nEnter USD amount to convert (or 0 to skip): $"))
            if custom_amount > 0:
                converted = convert_usd_to_cad(custom_amount, rate_info)
                print(f"\n${custom_amount:,.2f} USD = ${converted:,.2f} CAD")
        except ValueError:
            print("Invalid input. Skipping custom conversion.")
        except KeyboardInterrupt:
            print("\n\nProgram terminated by user.")
