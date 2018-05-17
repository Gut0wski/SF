<?php

namespace AppBundle\Controller;

use AppBundle\Form\Recover;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Http\Authentication\AuthenticationUtils;
use AppBundle\Entity\Users;
use AppBundle\Form\Register;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;
use AppBundle\Form\Profile;
use AppBundle\Form\Request as RequestForm;
use Symfony\Component\Security\Core\Authentication\Token\UsernamePasswordToken;
use AppBundle\Extend\Utils\Paginate;

/**
 * Контроллер пользователей
 * @package AppBundle\Controller
 */
class UsersController extends Controller
{
    /**
     * Регистрация пользователя
     * @param Request $request
     * @param UserPasswordEncoderInterface $encoder
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function registerAction(Request $request, UserPasswordEncoderInterface $encoder)
    {
        $user = new Users();
        $form = $this->createForm(Register::class, $user);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $user->setPassword($encoder->encodePassword($user, $user->getPassword()));
            $em = $this->getDoctrine()->getManager();
            $em->persist($user);
            $em->flush();
            $this->get('session')->getFlashBag()->add('success-notice', 'Вы были успешно зарегистрированы на сайте СНТ 
                "Степной Фазан". В ближайшее время администратор проверит ваш аккаунт и активирует его. Вы получите
                уведомление об этом на указанный вами e-mail.');
            return $this->redirectToRoute('login');
        }
        return $this->render('@App/users/register.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * Вход
     * @param Request $request
     * @param AuthenticationUtils $authenticationUtils
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function loginAction(Request $request, AuthenticationUtils $authenticationUtils)
    {
        return $this->render('@App/users/login.html.twig', [
            'error' => $authenticationUtils->getLastAuthenticationError(),
            'login' => $authenticationUtils->getLastUsername(),
        ]);
    }

    /**
     * Запрос на восстановление пароля
     * @param string $token код восстановления
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function recoverAction($token, Request $request)
    {
        if ($token){
            $userReset = $this->getDoctrine()
                ->getRepository('AppBundle:Users')
                ->findOneByPasswordReset($token);
            if ($userReset) {
                $userPasswordToken = new UsernamePasswordToken($userReset, null, 'main', $userReset->getRoles());
                $this->get('security.token_storage')->setToken($userPasswordToken);
                return $this->redirectToRoute('recover_password');
            }
        }
        $form = $this->createForm(RequestForm::class, $userReset);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $email = $form->get('email')->getData();
            $user = $this->getDoctrine()->getRepository('AppBundle:Users')->findOneByEmail($email);
            if ($user) {
                $this->get('app.security.recover')->send($user);
            }
            return $this->redirectToRoute('recover');
        }
        return $this->render('@App/users/recover.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * Восстановление пароля
     * @param Request $request
     * @param UserPasswordEncoderInterface $encoder
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function recoverPasswordAction(Request $request, UserPasswordEncoderInterface $encoder)
    {
        $user = $this->getUser();
        if(!$user->getPasswordReset()) {
            return $this->redirectToRoute('login');
        }
        $form = $this->createForm(Recover::class, $user);
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()){
            $password = $encoder->encodePassword($user, $form->get('password')->getData());
            $user->setPassword($password);
            $user->setPasswordReset(null);
            $em = $this->getDoctrine()->getManager();
            $em->persist($user);
            $em->flush();
            return $this->redirectToRoute('login');
        }
        return $this->render('@App/users/password.html.twig',[
            'form' => $form->createView()
        ]);
    }

    /**
     * Выход
     */
    public function logoutAction() {}

    /**
     * Редактирование профиля пользователя
     * @param Request $request
     *  @param UserPasswordEncoderInterface $encoder
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function profileAction(Request $request, UserPasswordEncoderInterface $encoder)
    {
        $profile = $this->getUser();
        $form = $this->createForm(Profile::class, $profile);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            if (!empty($form->get('password')->getData())) {
                $profile->setPassword($encoder->encodePassword($profile, $profile->getPassword()));
            }
            $em = $this->getDoctrine()->getManager();
            $em->persist($profile);
            $em->flush();
            $this->get('session')->getFlashBag()->add('success-notice', 'Ваш профиль успешно обновлен.');
            return $this->redirect($request->headers->get('referer'));
        }
        // история блокировок
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Blocks")
            ->getHistoryBlocksUser($this->getUser()->getId());
        $paginator = $this->get('knp_paginator');
        $blocks = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render('@App/users/profile.html.twig', [
            'form' => $form->createView(),
            'blocks' => $blocks
        ]);
    }

    /**
     * Вывод профилей пользователей
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function profilesAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Users")
            ->findBy(array(), ['dateRegister' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_rows'))
        );
        return $this->render("@App/users/profiles.html.twig", compact('list'));
    }

    /**
     * Присвоение роли пользователю
     * @param integer $user код пользователя
     * @param integer $role наименование роли
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function setRoleAction($user, $role, Request $request)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Users")
            ->findOneById($user);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $first = (empty($item->getRole())) ? true : false;
        $item->setRole($role);
        if ($first) {
            $this->get('app.security.activate')->send($item);
        }
        $em = $this->getDoctrine()->getManager();
        $em->persist($item);
        $em->flush();
        return $this->redirect($request->headers->get('referer'));
    }

    /**
     * Удаление пользователя
     * @param integer $id код пользователя
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Users")
            ->findOneById($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Users")
            ->findBy(array(), ['dateRegister' => 'DESC']);
        $em = $this->getDoctrine()->getManager();
        $em->remove($item);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('profiles', compact('page'));
    }
}