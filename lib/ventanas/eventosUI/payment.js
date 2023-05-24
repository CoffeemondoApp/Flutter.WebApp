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
            //hacer un split para obtener lo que hay antes de protocolVersion
            const tokenSplit = tokenString.split('protocolVersion');
            //obtener el token
            const tokenFinal = tokenSplit[0].slice(1, -3);
            //imprimir el token
            console.log(tokenFinal);
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