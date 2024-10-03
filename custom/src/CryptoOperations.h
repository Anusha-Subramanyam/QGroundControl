#ifndef CRYPTOOPERATIONS_H
#define CRYPTOOPERATIONS_H

#include <QObject>
#include <QByteArray>
#include <openssl/aes.h>

class CryptoOperations : public QObject
{
    Q_OBJECT
public:
    explicit CryptoOperations(QObject *parent = nullptr);

    static CryptoOperations *getInstance(){
        if(!instance){
            instance = new CryptoOperations();
        }
        return instance;
    }

    ~CryptoOperations();

    Q_INVOKABLE QByteArray encryption(QString e_text);
    Q_INVOKABLE QString decryption(QByteArray d_text);
    //QByteArray base64_decode(const QByteArray &data);


private:
    static CryptoOperations *instance;
};

#endif // CRYPTOOPERATIONS_H
