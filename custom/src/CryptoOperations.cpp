#include "CryptoOperations.h"
#include <cstring>
#include <openssl/aes.h>

CryptoOperations *CryptoOperations::instance = nullptr;
char *out;

CryptoOperations::CryptoOperations(QObject *parent)
    : QObject{parent}
{

}

CryptoOperations::~CryptoOperations()
{

}

QByteArray CryptoOperations::encryption( QString e_text)

{
    QByteArray ba = e_text.toUtf8();
    const int UserDataSize = ba.size();
    QVector<unsigned char> test2(UserDataSize);
    memcpy(test2.data(), ba.constData(), UserDataSize);
    int keylength = 128;
    unsigned char aes_key[] = "ABM1234567891011";
    unsigned char iv_enc[AES_BLOCK_SIZE] = {0}; // IV should be randomized in practice

    // Create AES key structure
    AES_KEY enc_key;
    AES_set_encrypt_key(aes_key, keylength, &enc_key);
    // Pad input data
    const int encsize = ((UserDataSize + AES_BLOCK_SIZE) / AES_BLOCK_SIZE) * AES_BLOCK_SIZE;
    QVector<unsigned char> enc_out(encsize);
    // Perform encryption
    AES_cbc_encrypt(test2.data(), enc_out.data(), UserDataSize, &enc_key, iv_enc, AES_ENCRYPT);
    // Encode encrypted data to Base64
    QByteArray encodedData = QByteArray::fromRawData(reinterpret_cast<const char*>(enc_out.data()), encsize);
    QByteArray result = encodedData.toBase64();
    return result;
}

QString CryptoOperations::decryption( QByteArray d_text)

{
    QByteArray decodedData = QByteArray::fromBase64(d_text);
    const int dataSize = decodedData.size();
    QVector<unsigned char> enc_out(dataSize);
    int keylength = 128;
    unsigned char aes_key[] = "ABM1234567891011";
    unsigned char iv_dec[AES_BLOCK_SIZE] = {0}; // IV should be the same as used for encryption
    AES_KEY dec_key;
    AES_set_decrypt_key(aes_key, keylength, &dec_key);
    // Perform decryption
    AES_cbc_encrypt(reinterpret_cast<const unsigned char*>(decodedData.constData()), enc_out.data(), dataSize, &dec_key, iv_dec, AES_DECRYPT);
    // Convert decrypted data to QString
    QByteArray decryptedData(reinterpret_cast<const char*>(enc_out.data()), dataSize);
    QString decryptedText = QString::fromUtf8(decryptedData.trimmed());
    return decryptedText;
}

