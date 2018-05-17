<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Класс для работы с таблицей "Контрольные показания"
 * @package AppBundle\Entity
 * @ORM\Table(name="measurements")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\MeasurementsRepository")
 */
class Measurements
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $date дата внесения
     * @ORM\Column(type="datetime", options={"default"="CURRENT_TIMESTAMP"})
     */
    private $date;

    /**
     * @var integer $type код тарифа
     * @ORM\ManyToOne(targetEntity="TariffsTypes")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="type", referencedColumnName="id")
     * })
     */
    private $type;

    /**
     * @var integer $user код пользователя
     * @ORM\Column(type="integer")
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumn(name="user", referencedColumnName="id")
     */
    private $user;

    /**
     * var double $value показание
     * @ORM\Column(type="decimal", precision=10, scale=2)
     */
    private $value;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->date = new \DateTime();
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
     * Set date
     * @param \DateTime $date
     * @return Measurements
     */
    public function setDate(\DateTime $date)
    {
        $this->date = $date;
        return $this;
    }

    /**
     * Get date
     * @return \DateTime
     */
    public function getDate()
    {
        return $this->date;
    }

    /**
     * Set type
     * @param TariffsTypes $type
     * @return Measurements
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
     * Set user
     * @param integer $user
     * @return Measurements
     */
    public function setUser($user)
    {
        $this->user = $user;
        return $this;
    }

    /**
     * Get user
     * @return integer
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * Set value
     * @param string $value
     * @return Measurements
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
