// Récupère l'écran de la calculatrice
const resultField = document.getElementById('result');

// Ajoute un chiffre ou un opérateur à l'écran
function appendValue(value) {
  resultField.value += value;
}

// Efface tout l'écran
function clearDisplay() {
  resultField.value = '';
}

// Supprime le dernier caractère
function deleteLast() {
  resultField.value = resultField.value.slice(0, -1);
}
// Effectue le calcul
function calculate() {
    const expression = resultField.value;
    const operators = ['+', '-', '*', '/'];
  
    // Vérifie si l'expression contient un opérateur valide
    for (const operator of operators) {
      if (expression.includes(operator)) {
        const [a, b] = expression.split(operator).map(Number);
  
        if (isNaN(a) || isNaN(b)) {
          resultField.value = 'Erreur: Expression invalide';
          return;
        }
  
        // Détermine l'API correspondante
        let url;
        switch (operator) {
          case '+':
            url = '/api/v1/add';
            break;
          case '-':
            url = '/api/v1/subtract';
            break;
          case '*':
            url = '/api/v1/multiply';
            break;
          case '/':
            if (b === 0) {
              resultField.value = 'Erreur: Division par 0';
              return;
            }
            url = '/api/v1/divide';
            break;
          default:
            resultField.value = 'Erreur';
            return;
        }
  
        // Envoyer une requête POST à l'API
        fetch(url, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ a, b }),
        })
          .then(response => response.json())
          .then(data => {
            if (data.id) {
              // Affiche les détails de l'opération dans l'écran
              resultField.value = `
  ID: ${data.id}
  Opération: ${data.type_operation}
  a: ${data.a}, b: ${data.b}
  Résultat: ${eval(`${data.a} ${operator} ${data.b}`)}
  `.trim();
            } else if (data.error) {
              resultField.value = `Erreur: ${data.error}`;
            }
          })
          .catch(() => {
            resultField.value = 'Erreur de connexion';
          });
  
        return;
      }
    }
  
    resultField.value = 'Expression invalide';
  }
