<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Класс для работы с таблицей "Платежи"
 * @package AppBundle\Entity
 * @ORM\Table(name="payments")
 * @ORM\Entity
 */
class Payments
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $date дата платежа
     * @ORM\Column(type="datetime")
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
     * @var double $sum сумма
     * @ORM\Column(type="decimal", precision=10, scale=2)
     */
    private $sum;

    /**
     * @var string $place место оплаты
     * @ORM\Column(type="string", length=500, nullable=true)
     */
    private $place;

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
     * @return Payments
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
     * @return Payments
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
     * @return Payments
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
     * Set sum
     * @param string $sum
     * @return Payments
     */
    public function setSum($sum)
    {
        $this->sum = $sum;
        return $this;
    }

    /**
     * Get sum
     * @return string
     */
    public function getSum()
    {
        return $this->sum;
    }

    /**
     * Set place
     * @param string $place
     * @return Payments
     */
    public function setPlace($place)
    {
        $this->place = $place;
        return $this;
    }

    /**
     * Get place
     * @return string
     */
    public function getPlace()
    {
        return $this->place;
    }
}
