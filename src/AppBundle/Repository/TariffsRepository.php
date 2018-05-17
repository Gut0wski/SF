<?php

namespace AppBundle\Repository;

use Doctrine\ORM\EntityRepository;

class TariffsRepository extends EntityRepository
{
    /**
     * Выборка актуальных тарифов
     * @return array
     */
    public function getTariffsActual()
    {
        return $this->getEntityManager()
            ->createQueryBuilder()
            ->select('a')
            ->from('AppBundle:TariffsActual', 'a')
            ->getQuery()
            ->getResult();
    }

    /**
     * Выборка сортированной истории тарифов
     * @return array
     */
    public function getTariffsSortHistory()
    {
        return $this->getEntityManager()
            ->createQueryBuilder()
            ->select('a')
            ->from('AppBundle:TariffsSortHistory', 'a')
            ->getQuery()
            ->getResult();
    }
}