<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use AppBundle\Entity\TariffsTypes;

/**
 * Класс для работы с таблицей "Тарифы"
 * @package AppBundle\Entity
 * @ORM\Table(name="tariffs")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\TariffsRepository")
 */
class Tariffs
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
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
     * @ORM\Column(type="string", length=10, name="period_start")
     */
    private $periodStart;

    /**
     * @var double $value значение
     * @ORM\Column(type="decimal", precision=10, scale=2)
     */
    private $value;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->type = new ArrayCollection();
    }

    /**
     * Get id
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set type
     * @param TariffsTypes $type
     * @return Tariffs
     */
    public function setType(TariffsTypes $type)
    {
        $this->type = $type;
        return $this;
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
     * Set periodStart
     * @param string $periodStart
     * @return Tariffs
     */
    public function setPeriodStart($periodStart)
    {
        $this->periodStart = $periodStart;
        return $this;
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
     * Set value
     * @param string $value
     * @return Tariffs
     */
    public function setValue($value)
    {
        $this->value = $value;
        return $this;
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
