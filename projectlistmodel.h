#ifndef PROJECTLISTMODEL_H
#define PROJECTLISTMODEL_H

#include <QAbstractListModel>

class ProjectList;

class ProjectListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ProjectListModel(QObject *parent = 0);
    ~ProjectListModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void setProjectList(ProjectList *projList) { m_projectList = projList; }
    ProjectList* getProjectList() const { return m_projectList; }

    void addItem(QString& str);
    void removeItem(int i);
    void renameItem(int i, QString& str);

signals:

public slots:

private:
    ProjectList* m_projectList;
};

#endif // PROJECTLISTMODEL_H
