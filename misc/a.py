import requests
import json
from pathlib import Path

# Configuração
API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
API_KEY = "AIzaSyBIwlGjycbAZNA3bLbt7RTqjRfB05qmZBQ"  # Substitua pela sua chave de API
INPUT_FILE = "input.txt"
OUTPUT_FILE = "output.txt"

def read_full_prompt(input_file):
    """Lê o arquivo inteiro como um único prompt (preserva quebras de linha)"""
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            return f.read().strip()  # Lê tudo e remove espaços extras no início/fim
    except FileNotFoundError:
        print(f"Erro: Arquivo de entrada '{input_file}' não encontrado.")
        return None

def query_gemini(api_key, prompt):
    """Envia o prompt para a API Gemini e retorna a resposta"""
    headers = {
        'Content-Type': 'application/json',
        'X-goog-api-key': api_key
    }
    
    payload = {
        "contents": [{
            "parts": [{"text": prompt}]
        }]
    }
    
    try:
        response = requests.post(API_URL, headers=headers, json=payload)
        response.raise_for_status()  # Verifica erros HTTP
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Falha na requisição para o prompt:\n{prompt[:200]}...\nErro: {e}")
        return None

def extract_response_text(response):
    """Extrai o texto gerado da resposta da API"""
    if not response:
        return "Erro: Nenhuma resposta da API"
    
    try:
        if 'candidates' in response and response['candidates']:
            parts = response['candidates'][0]['content'].get('parts', [])
            return '\n'.join(part.get('text', '') for part in parts)
        return "Erro: Formato inesperado da resposta"
    except Exception as e:
        return f"Erro ao processar resposta: {str(e)}"

def write_response(output_file, prompt, response):
    """Grava o prompt e a resposta no arquivo de saída"""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"Resposta:\n{response}\n")

def main():
    # Lê o prompt completo do arquivo
    prompt = read_full_prompt(INPUT_FILE)
    if not prompt:
        return  # Encerra se não houver prompt
    
    print(f"Processando prompt (tamanho: {len(prompt)} caracteres)...")
    api_response = query_gemini(API_KEY, prompt)
    response_text = extract_response_text(api_response)
    
    write_response(OUTPUT_FILE, prompt, response_text)
    print(f"\nResposta salva em '{OUTPUT_FILE}'")

if __name__ == "__main__":
    # Cria o arquivo de entrada se não existir
    if not Path(INPUT_FILE).exists():
        with open(INPUT_FILE, 'w', encoding='utf-8') as f:
            f.write("""Explique, em detalhes, como a inteligência artificial generativa funciona.
Inclua exemplos de modelos como GPT-4, Gemini e Claude.
Mantenha a explicação técnica, mas acessível para iniciantes.""")
        print(f"Arquivo '{INPUT_FILE}' criado com um prompt de exemplo.")
    
    main()
