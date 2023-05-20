function onPaymentAuthorized(paymentData) {
    return new Promise(function(resolve, reject){
      // handle the response
      processPayment(paymentData)
        .then(function() {
          resolve({transactionState: 'SUCCESS'});
       window.parent.postMessage('MENSAJE EXITOSO', "*");
       const token = paymentData.paymentMethodData.tokenizationData.signature;
       //imprimir el tipo de dato que es el token
         console.log(typeof token);
         //convertir object token a string
            const tokenString = JSON.stringify(token);
            //convertir tokenstring a string
            const tokenString2 = tokenString.toString();
            //imprimir el token
            console.log(tokenString2);
        })
        .catch(function() {
          resolve({
            transactionState: 'ERROR',
            error: {
              intent: 'PAYMENT_AUTHORIZATION',
              message: 'Insufficient funds, try again. Next attempt should work.',
              reason: 'PAYMENT_DATA_INVALID'
            }
          });
          });
    });
  }