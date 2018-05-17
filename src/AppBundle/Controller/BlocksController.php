<?php

namespace AppBundle\Controller;

use AppBundle\Form\Block as BlockForm;
use AppBundle\Entity\Blocks;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * Контроллер блокировок пользователей
 * @package AppBundle\Controller
 */
class BlocksController extends Controller
{
    /**
     * Вывод списка блокировок
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Blocks")
            ->findBy(array(), ['dateStart' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_rows'))
        );
        return $this->render("@App/blocks/list.html.twig", [
            'list' => $list,
            'curDate' => date("Y-m-d H:i")
        ]);
    }

    /**
     * Новая блокировка
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newAction($user, Request $request)
    {
        $session = $request->getSession();
        $block = new Blocks();
        $form = $this->createForm(BlockForm::class, $block);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $object_user = $this->getDoctrine()
                ->getRepository("AppBundle:Users")
                ->findOneById($user);
            $object_moderator = $this->getDoctrine()
                ->getRepository("AppBundle:Users")
                ->findOneById($this->getUser()->getId());
            $block->setUser($object_user);
            $block->setModerator($object_moderator);
            $em = $this->getDoctrine()->getManager();
            $em->persist($block);
            $em->flush();
            $this->get('session')->getFlashBag()->add('success-notice', 'Пользователь заблокирован');
            return $this->redirect($session->get('return_url'));
        }
        $session->set('return_url', $request->headers->get('referer'));
        return $this->render("@App/blocks/new.html.twig", [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Разблокировка пользователя
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function unblockAction($user, Request $request) {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Blocks")
            ->findOneById($user);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $item->setDateEnd(new \DateTime());
        $em = $this->getDoctrine()->getManager();
        $em->persist($item);
        $em->flush();
        return $this->redirect($request->headers->get('referer'));
    }
}