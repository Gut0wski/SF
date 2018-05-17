<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use AppBundle\Entity\TariffsTypes;

/**
 * Класс для работы с представлением "Сортированная история тарифов"
 * @package AppBundle\Entity
 * @ORM\Table(name="tariffs_sort_history")
 * @ORM\Entity
 */
class TariffsSortHistory
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     */
    private $id;

    /**
     * @var integer $type тип тарифа
     * @ORM\ManyToOne(targetEntity="TariffsTypes")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="type", referencedColumnName="id")
     * })
     */
    private $type;

    /**
     * @var string $periodStart период начала действия
     * @ORM\Column(type="string", name="period_start")
     */
    private $periodStart;

    /**
     * @var double $value значение
     * @ORM\Column(type="decimal")
     */
    private $value;

    /**
     * Get id
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Get type
     * @return TariffsTypes
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Get periodStart
     * @return string
     */
    public function getPeriodStart()
    {
        return $this->periodStart;
    }

    /**
     * Get value
     * @return string
     */
    public function getValue()
    {
        return $this->value;
    }
}