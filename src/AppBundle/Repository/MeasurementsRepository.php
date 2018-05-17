<?php

namespace AppBundle\Repository;

use Doctrine\ORM\EntityRepository;

class MeasurementsRepository extends EntityRepository
{
    /**
     * Расчетная ведомость пользователя
     * @param integer $id код пользователя
     * @return array
     */
    public function getCalculate($id)
    {
        $em = $this->getEntityManager();
        $statement = $em->getConnection()->prepare('call calculate(:id);');
        $statement->bindValue('id', $id);
        $statement->execute();
        return $statement->fetchAll();
    }
}