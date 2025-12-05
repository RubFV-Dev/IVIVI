#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QMediaPlayer>
#include <QAudioOutput>

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    app.setOrganizationName("UAA");
    app.setApplicationName("IVIVI");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("IVIVI", "Main");

    return app.exec();
}