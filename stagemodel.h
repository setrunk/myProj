#ifndef STAGEMODEL_H
#define STAGEMODEL_H

#include <QAbstractListModel>

class Stage;

class StageModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit StageModel(QObject *parent = 0);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void setStage(Stage *stage) { m_stage = stage; }
    Stage* getStage() const { return m_stage; }

    void addItem(QString& str);
    void moveItem(int from, int to);
    void removeItem(int i);
    void renameItem(int i, QString& str);

signals:

public slots:

private:
    Stage* m_stage;
};

#endif // STAGEMODEL_H
