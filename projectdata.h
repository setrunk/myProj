#ifndef PROJECTDATA_H
#define PROJECTDATA_H

#include <QObject>
#include <QList>

class Videofile
{
public:
    QString name;
    QString path;
    QString play_time;
    QString preview;
    QString preview_length;
    QList<QString> thumbnail;
};

class Subqueue
{
public:
    QString name;
    QString desc;
    QList<Videofile*> files;
};

class Queue
{
public:
    QString name;
    QString desc;
    QList<Subqueue*> children;
};

class Stage
{
public:
    QString name;
    QString desc;
    QList<Queue*> children;
};

class Project
{
public:
    QString name;
    QString desc;
    QList<Stage*> children;
};

class ProjectList
{
public:
    QList<Project*> children;
};

class ProjectListModel;
class ProjectModel;
class StageModel;
class QueueModel;
class SubqueueModel;

class ProjectData : public QObject
{
    Q_OBJECT
public:
    explicit ProjectData(QObject *parent = 0);

    void initProjectList(const QJsonObject& obj);
    void addProject(ProjectList *projList, const QJsonObject& obj);
    void addStage(Project* proj, const QJsonObject& obj);
    void addQueue(Stage* stage, const QJsonObject& obj);
    void addSubqueue(Queue* queue, const QJsonObject& obj);
    void addVideofile(Subqueue* subqueue, const QJsonObject& obj);

    void saveProject(QJsonArray& json, Project *p);
    void saveStage(QJsonArray& json, Stage *s);
    void saveQueue(QJsonArray& json, Queue *q);
    void saveSubqueue(QJsonArray& json, Subqueue *sq);
    void saveVideofile(QJsonArray& json, Videofile *v);

signals:

public slots:    

    // project
    void newProject(QString name);
    void removeProject(int i) { m_currProjectList->children.removeAt(i); }
    void renameProject(int i, QString str) { m_currProjectList->children[i]->desc = str; }
    void moveProject(int from, int to) { m_currProjectList->children.swap(from, to); }
    int getProjectCount() const { return m_currProjectList->children.count(); }
    QString getProjectName(int i) const{ return m_currProjectList->children[i]->desc; }

    // stage
    void newStage(int project, QString name);
    void removeStage(int project, int i) { m_currProjectList->children[project]->children.removeAt(i); }
    void renameStage(int project, int i, QString str) { m_currProjectList->children[project]->children[i]->desc = str; }
    void moveStage(int project, int from, int to) { m_currProjectList->children[project]->children.swap(from, to); }
    int getStageCount(int project) const { return m_currProjectList->children[project]->children.count(); }
    QString getStageName(int project, int i) const { return m_currProjectList->children[project]->children[i]->desc; }

    // queue
    void newQueue(int project, int stage, QString name);
    void removeQueue(int project, int stage, int i) { m_currProjectList->children[project]->children[stage]->children.removeAt(i); }
    void renameQueue(int project, int stage, int i, QString str) { m_currProjectList->children[project]->children[stage]->children[i]->desc = str; }
    void moveQueue(int project, int stage, int from, int to) { m_currProjectList->children[project]->children[stage]->children.swap(from, to); }
    int getQueueCount(int project, int stage) const { return m_currProjectList->children[project]->children[stage]->children.count(); }
    QString getQueueName(int project, int stage, int i) const { return m_currProjectList->children[project]->children[stage]->children[i]->desc; }
    QString getQueueThumbnail(int project, int stage, int i) const;

    // subqueue
    void newSubqueue(int project, int stage, int queue, QString name);
    void removeSubqueue(int project, int stage, int queue, int i) { m_currProjectList->children[project]->children[stage]->children[queue]->children.removeAt(i); }
    void renameSubqueue(int project, int stage, int queue, int i, QString str) { m_currProjectList->children[project]->children[stage]->children[queue]->children[i]->desc = str; }
    void moveSubqueue(int project, int stage, int queue, int from, int to) { m_currProjectList->children[project]->children[stage]->children[queue]->children.swap(from, to); }
    int getSubqueueCount(int project, int stage, int queue) const { return m_currProjectList->children[project]->children[stage]->children[queue]->children.count(); }
    QString getSubqueueName(int project, int stage, int queue, int i) const { return m_currProjectList->children[project]->children[stage]->children[queue]->children[i]->desc; }
    QString getSubqueueThumbnail(int project, int stage, int queue, int i) const;

    // video
    void newVideo(int project, int stage, int queue, int subqueue, QString name);
    int getVideoCount(int project, int stage, int queue, int subqueue) const {return m_currProjectList->children[project]->children[stage]->children[queue]->children[subqueue]->files.count(); }
    QString getVideoName(int project, int stage, int queue, int subqueue, int i) const { return m_currProjectList->children[project]->children[stage]->children[queue]->children[subqueue]->files[i]->name; }
    QString getVideoThumbnail(int project, int stage, int queue, int subqueue, int i) const;

    void save();

private:
    QString m_path;
    ProjectList* m_currProjectList;
    Project* m_currProject;
    Stage* m_currStage;
    Queue* m_currQueue;
    Subqueue* m_currSubqueue;
};

#endif // PROJECTDATA_H
