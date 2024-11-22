// Récupère l'écran de la calculatrice
const resultField = document.getElementById('result');
const information = document.getElementById('information');
var oper_identifiant = 0;

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
            url = 'http://127.0.0.1:5000/api/addition';
            break;
          case '-':
            url = 'http://127.0.0.1:5000/api/soustraction';
            break;
          case '*':
            url = 'http://127.0.0.1:5000/api/multiplication';
            break;
          case '/':
            if (b === 0) {
              resultField.value = 'Erreur: Division par 0';
              return;
            }
            url = 'http://127.0.0.1:5000/api/division';
            break;
          default:
            resultField.value = 'Erreur';
            return;
        }
  
        // Envoyer une requête POST à l'API
        fetch(url, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({"num1" : a, "num2" : b }),
        })
          .then(response => response.json())
          .then(data => {
            if (data) {
                         oper_identifiant = data.id;
                        // Affiche les détails de l'opération dans l'écran
                        information.value = `
                      "status": ${data.status}, "id de l'opération" : ${data.id} ,  "message de l'api" : ${data.message}
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
 

  function getResult() {
    const url = "http://127.0.0.1:5000/api/result/" + oper_identifiant;
    fetch(url, {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
    })
    .then(response => response.json())
    .then(data => {
      if (data.result) {
        // Affiche les détails de l'opération dans l'écran
        information.value = `Le résultat est : ${data.result}`.trim();
      } else if (data.error) {
        resultField.value = `Erreur: ${data.error}`;
      }
    })
    .catch(() => {
      information.value = 'Erreur de connexion';
    });
}