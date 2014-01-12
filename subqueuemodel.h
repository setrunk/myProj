#ifndef SUBQUEUEMODEL_H
#define SUBQUEUEMODEL_H

#include <QAbstractListModel>

class Subqueue;

class SubqueueModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum {
        NameRole = Qt::UserRole + 1,
        Image1Role,
        Image2Role,
        Image3Role,
    };

    explicit SubqueueModel(QObject *parent = 0);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void setSubqueue(Subqueue* queue) { m_subqueue = queue; }
    Subqueue* getSubqueue() const { return m_subqueue; }

protected:
    QHash<int, QByteArray> roleNames() const;

signals:

public slots:

private:
    Subqueue* m_subqueue;
};

#endif // SUBQUEUEMODEL_H
