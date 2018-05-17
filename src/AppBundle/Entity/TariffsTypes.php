<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;

/**
 * Класс для работы с таблицей "Типы тарифов"
 * @package AppBundle\Entity
 * @ORM\Table(name="tariffs_types")
 * @ORM\Entity
 * @UniqueEntity(fields={"title"}, message="Такой тип уже существует")
 */
class TariffsTypes
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $title заголовок тарифа
     * @ORM\Column(type="string", length=200, unique=true)
     */
    private $title;

    /**
     * @var boolean $calculate необходим ли съем показаний (0 - нет, 1 - да)
     * @ORM\Column(type="boolean", options={"default" : 1})
     */
    private $calculate;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->calculate = 1;
    }

    /**
     * Get id
     *
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set title
     * @param string $title
     * @return TariffsTypes
     */
    public function setTitle($title)
    {
        $this->title = $title;
        return $this;
    }

    /**
     * Get title
     * @return string
     */
    public function getTitle()
    {
        return $this->title;
    }

    /**
     * Set calculate
     * @param boolean $calculate
     * @return TariffsTypes
     */
    public function setCalculate($calculate)
    {
        $this->calculate = $calculate;
        return $this;
    }

    /**
     * Get calculate
     * @return boolean
     */
    public function getCalculate()
    {
        return $this->calculate;
    }
}
