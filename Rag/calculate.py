def convert_currency(amount, from_currency, to_currency):
    exchange_rate = 25950  # 1 USD = 25950 VND
    
    if from_currency == 'USD' and to_currency == 'VND':
        return amount * exchange_rate
    elif from_currency == 'VND' and to_currency == 'USD':
        return amount / exchange_rate
    else:
        raise ValueError("Chỉ hỗ trợ chuyển đổi giữa USD và VND")