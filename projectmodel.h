#ifndef PROJECTMODEL_H
#define PROJECTMODEL_H

#include <QAbstractListModel>

class Project;

class ProjectModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ProjectModel(QObject *parent = 0);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void setProject(Project* proj) { m_project = proj; }
    Project* getProject() const { return m_project; }

    void addItem(QString& str);
    void removeItem(int i);
    void renameItem(int i, QString& str);

signals:

public slots:

private:
    Project* m_project;
};

#endif // PROJECTMODEL_H
