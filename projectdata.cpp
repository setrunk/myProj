#include "projectdata.h"
#include <QFile>
#include <QByteArray>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonArray>
#include <QJsonObject>
#include <QDir>

#include "projectlistmodel.h"
#include "projectmodel.h"
#include "stagemodel.h"
#include "queuemodel.h"
#include "subqueuemodel.h"

ProjectData::ProjectData(QObject *parent) :
    QObject(parent), m_currProjectList(new ProjectList)
{    
    QString path = QDir::currentPath() + "/res/treeInit.json";
    QFile file(path);
    if (file.open(QFile::ReadOnly))
    {
        QByteArray byte_array = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(byte_array);
        if (!doc.isArray())
            return;

        // player list
        QJsonObject obj = doc.array().at(0).toObject();
        QString name = obj["name"].toString(); // "Player List"
        QString desc = obj["desc"].toString(); // ""
        initProjectList(obj);
    }
}

void ProjectData::initProjectList(const QJsonObject &obj)
{
    QJsonArray children = obj["children"].toArray();
    for (int i = 0; i < children.count(); ++i)
    {
        addProject(m_currProjectList, children.at(i).toObject());
    }
}

void ProjectData::addProject(ProjectList *projList, const QJsonObject &obj)
{
    Project* proj = new Project();
    projList->children << proj;

    proj->name = obj["name"].toString();
    proj->desc = obj["desc"].toString();

    QJsonArray children = obj["children"].toArray();
    for (int i = 0; i < children.count(); ++i)
    {
        addStage(proj, children.at(i).toObject());
    }
}

void ProjectData::addStage(Project *proj, const QJsonObject &obj)
{
    Stage *stage = new Stage();
    proj->children << stage;

    stage->name = obj["name"].toString();
    stage->desc = obj["desc"].toString();

    QJsonArray children = obj["children"].toArray();
    for (int i = 0; i < children.count(); ++i)
    {
        addQueue(stage, children.at(i).toObject());
    }
}

void ProjectData::addQueue(Stage *stage, const QJsonObject &obj)
{
    Queue *queue = new Queue();
    stage->children << queue;

    queue->name = obj["name"].toString();
    queue->desc = obj["desc"].toString();

    QJsonArray children = obj["children"].toArray();
    for (int i = 0; i < children.count(); ++i)
    {
        addSubqueue(queue, children.at(i).toObject());
    }
}

void ProjectData::addSubqueue(Queue *queue, const QJsonObject &obj)
{
    Subqueue *subqueue = new Subqueue();
    queue->children << subqueue;

    subqueue->name = obj["name"].toString();
    subqueue->desc = obj["desc"].toString();

    QJsonArray files = obj["files"].toArray();
    for (int i = 0; i < files.count(); ++i)
    {
        addVideofile(subqueue, files.at(i).toObject());
    }
}

void ProjectData::addVideofile(Subqueue *subqueue, const QJsonObject &obj)
{
    Videofile *file = new Videofile();
    subqueue->files << file;

    file->path = obj["name"].toString();
    QStringList strList = file->path.split("/");
    file->name = strList.back();
    file->play_time = obj["play_time"].toString();
    file->preview = obj["preview"].toString();
    file->preview_length = obj["preview_length"].toString();

    QJsonArray thumbnail = obj["thumbnail"].toArray();
    for (int i = 0; i < thumbnail.count(); ++i)
    {
        file->thumbnail << thumbnail.at(i).toString();
    }
}

void ProjectData::newProject(QString name)
{
    Project *p = new Project();
    p->name = tr("project");
    p->desc = name;
    m_currProjectList->children << p;

    newStage(m_currProjectList->children.count() - 1, tr("Stage 1"));
}

void ProjectData::newStage(int project, QString name)
{
    Project *p = m_currProjectList->children[project];
    Stage *s = new Stage();
    s->name = tr("stage");
    s->desc = name;
    p->children << s;

    newQueue(project, p->children.count() - 1, tr("Queue 1"));
}

void ProjectData::newQueue(int project, int stage, QString name)
{
    Stage *s = m_currProjectList->children[project]->children[stage];
    Queue *q = new Queue();
    q->name = tr("queue");
    q->desc = name;
    s->children << q;

    newSubqueue(project, stage, s->children.count() - 1, tr("Subqueue 1"));
}

void ProjectData::newSubqueue(int project, int stage, int queue, QString name)
{
    Queue *q = m_currProjectList->children[project]->children[stage]->children[queue];
    Subqueue *sq = new Subqueue();
    sq->name = tr("subqueue");
    sq->desc = name;
    q->children << sq;
}

QString ProjectData::getQueueThumbnail(int project, int stage, int i) const
{
    Queue *q = m_currProjectList->children[project]->children[stage]->children[i];
    if (q->children.count())
    {
        Subqueue *sq = q->children[0];
        if (sq->files.count())
            return getVideoThumbnail(project, stage, i, 0, 0);
    }
    return QString();
}

QString ProjectData::getSubqueueThumbnail(int project, int stage, int queue, int i) const
{
    Subqueue *sq = m_currProjectList->children[project]->children[stage]->children[queue]->children[i];
    if (sq->files.count())
    {
        return getVideoThumbnail(project, stage, queue, i, 0);
    }
    return QString();
}

void ProjectData::newVideo(int project, int stage, int queue, int subqueue, QString name)
{
    Videofile *v = new Videofile();
    v->name = name;
    v->path = tr("");
    v->play_time = tr("");
    v->preview = tr("");
    v->preview_length = tr("");
    v->thumbnail;
    m_currProjectList->children[project]->children[stage]->children[queue]->children[subqueue]->files.append(v);
}

QString ProjectData::getVideoThumbnail(int project, int stage, int queue, int subqueue, int i) const
{
    QString path = "C:/work/DQ_Hospital/player_2013_12_08/webserver/public";
    QString str = m_currProjectList->children[project]->children[stage]->children[queue]->children[subqueue]->files[i]->thumbnail[0];
    if (str.startsWith('.'))
        str.remove(0, 1);
    return tr("file:///") + path + str;
}

void ProjectData::save()
{
    QString path = QDir::currentPath() + "/res/treeInit2.json";
    QFile file(path);
    if (file.open(QFile::WriteOnly))
    {
        QJsonArray projArray;
        if (m_currProjectList)
        {
            for (int i = 0; i < m_currProjectList->children.count(); ++i)
                saveProject(projArray, m_currProjectList->children[i]);
        }

        QJsonObject json;
        json["children"] = projArray;
        json["desc"] = tr("");
        json["name"] = tr("Player List");
        QJsonArray root;
        root.append(json);
        QJsonDocument doc(root);
        file.write(doc.toJson());
    }
}

void ProjectData::saveProject(QJsonArray &json, Project *p)
{
    QJsonArray array;
    for (int i = 0; i < p->children.count(); ++i)
        saveStage(array, p->children[i]);

    QJsonObject obj;
    obj["children"] = array;
    obj["desc"] = p->desc;
    obj["name"] = p->name;
    json.append(obj);
}

void ProjectData::saveStage(QJsonArray &json, Stage *s)
{
    QJsonArray array;
    for (int i = 0; i < s->children.count(); ++i)
        saveQueue(array, s->children[i]);

    QJsonObject obj;
    obj["children"] = array;
    obj["desc"] = s->desc;
    obj["name"] = s->name;
    json.append(obj);
}

void ProjectData::saveQueue(QJsonArray &json, Queue *q)
{
    QJsonArray array;
    for (int i = 0; i < q->children.count(); ++i)
        saveSubqueue(array, q->children[i]);

    QJsonObject obj;
    obj["children"] = array;
    obj["desc"] = q->desc;
    obj["name"] = q->name;
    json.append(obj);
}

void ProjectData::saveSubqueue(QJsonArray &json, Subqueue *sq)
{
    QJsonArray array;
    for (int i = 0; i < sq->files.count(); ++i)
        saveVideofile(array, sq->files[i]);

    QJsonObject obj;
    obj["files"] = array;
    obj["desc"] = sq->desc;
    obj["name"] = sq->name;
    json.append(obj);
}

void ProjectData::saveVideofile(QJsonArray &json, Videofile *v)
{
    QJsonArray array;
    for (int i = 0; i < v->thumbnail.count(); ++i)
        array.append(v->thumbnail[i]);

    QJsonObject obj;
    obj["name"] = v->path;
    obj["play_time"] = v->play_time;
    obj["preview"] = v->preview;
    obj["preview_length"] = v->preview_length;
    obj["thumbnail"] = array;

    json.append(obj);
}
