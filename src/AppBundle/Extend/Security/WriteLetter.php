<?php

namespace AppBundle\Extend\Security;

use Doctrine\ORM\EntityManager;
use Symfony\Bundle\FrameworkBundle\Routing\Router;

/**
 * Класс отправки письма администратору
 * @package AppBundle\Extend\Security
 */
class WriteLetter
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
    private $emailUser;

    /**
     * @var string email администратора
     */
    private $emailAdmin;

    /**
     * Конструктор
     * @param \Swift_Mailer $mailer
     * @param \Twig_Environment $twig
     * @param EntityManager $entity_manager
     * @param Router $router
     * @param string $emailUser
     * @param string $emailAdmin
     */
    public function __construct( \Swift_Mailer $mailer, \Twig_Environment $twig, EntityManager $entity_manager, Router $router, $emailUser, $emailAdmin)
    {
        $this->mailer = $mailer;
        $this->twig = $twig;
        $this->em = $entity_manager;
        $this->router = $router;
        $this->emailUser = $emailUser;
        $this->emailAdmin = $emailAdmin;
    }

    /**
     * Отправка письма
     * @param array $data
     * @return bool
     */
    public function send($data)
    {
        $template = $this->twig->render('@App/mail/write.html.twig',[
            'subject' => $data['subject'],
            'name' => $data['name'],
            'email' => $data['email'],
            'message' => $data['message'],
        ]);
        $mail = (new \Swift_Message('Вопрос посетителя сайта'))
            ->setFrom([$this->emailUser => 'Робот сайта СНТ "Степной фазан"'])
            ->setTo($this->emailAdmin)
            ->setBody($template, 'text/html');
        $status = $this->mailer->send($mail);
        if($status){
            return true;
        } else
            return false;
    }
}