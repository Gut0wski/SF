<?php

namespace AppBundle\Extend\Security;

use AppBundle\Extend\Utils\TokenGenerator;
use Doctrine\ORM\EntityManager;
use Symfony\Bundle\FrameworkBundle\Routing\Router;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;
use AppBundle\Entity\Users;

/**
 * Класс активации пользователя
 * @package AppBundle\Extend\Security
 */
class Activate
{
    /**
     * @var \Swift_Mailer почтовик
     */
    private $mailer;

    /**
     * @var \Twig_Environment шаблон
     */
    private $twig;

    /**
     * @var EntityManager модель пользователя
     */
    private $em;

    /**
     * @var Router роутер
     */
    private $router;

    /**
     * @var string email
     */
    private $email;

    /**
     * Конструктор
     * @param \Swift_Mailer $mailer
     * @param \Twig_Environment $twig
     * @param EntityManager $entity_manager
     * @param Router $router
     * @param $email
     */
    public function __construct( \Swift_Mailer $mailer, \Twig_Environment $twig, EntityManager $entity_manager, Router $router, $email)
    {
        $this->mailer = $mailer;
        $this->twig = $twig;
        $this->em = $entity_manager;
        $this->router = $router;
        $this->email = $email;
    }

    /**
     * Отправка письма с информацией об активации
     * @param Users $user
     * @return bool
     */
    public function send(Users $user)
    {
        $fio = $user->getFio();
        $login = $user->getUsername();
        $template = $this->twig->render('@App/mail/activate.html.twig',[
            'fio'=> $fio,
            'login'=> $login
        ]);
        $mail = (new \Swift_Message('Активация аккаунта'))
            ->setFrom([$this->email => 'Робот сайта СНТ "Степной фазан"'])
            ->setTo($user->getEmail())
            ->setBody($template, 'text/html');
        $status = $this->mailer->send($mail);
        if($status){
            return true;
        } else
            return false;
    }
}