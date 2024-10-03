#ifndef CUSTOMQGCAPPLICATION_H
#define CUSTOMQGCAPPLICATION_H

#include <QGCApplication.h>
#include <QObject>

class CustomQGCApplication : public QGCApplication
{
    Q_OBJECT
public:
    CustomQGCApplication(int &argc, char* argv[],bool unitTesting);

};

#endif // CUSTOMQGCAPPLICATION_H
