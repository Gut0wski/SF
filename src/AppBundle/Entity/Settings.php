<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;

/**
 * Класс для работы с таблицей "Настройки"
 * @package AppBundle\Entity
 * @ORM\Table(name="settings")
 * @ORM\Entity
 * @UniqueEntity(fields={"parameter"}, message="Такой параметр уже существует")
 */
class Settings
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $parameter наименование параметра
     * @ORM\Column(type="string", length=50, unique=true)
     */
    private $parameter;

    /**
     * @var string $description описание параметра
     * @ORM\Column(type="string", length=300)
     */
    private $description;

    /**
     * @var string $value значение параметра
     * @ORM\Column(type="string", length=300)
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
     * Set parameter
     * @param string $parameter
     * @return Settings
     */
    public function setParameter($parameter)
    {
        $this->parameter = $parameter;
        return $this;
    }

    /**
     * Get parameter
     * @return string
     */
    public function getParameter()
    {
        return $this->parameter;
    }

    /**
     * Set description
     * @param string $description
     * @return Settings
     */
    public function setDescription($description)
    {
        $this->description = $description;
        return $this;
    }

    /**
     * Get description
     * @return string
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * Set value
     * @param string $value
     * @return Settings
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
