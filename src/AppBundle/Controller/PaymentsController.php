<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Payments;
use AppBundle\Form\Payment;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Extend\Utils\Paginate;

/**
 * Контроллер платежей
 * @package AppBundle\Controller
 */
class PaymentsController extends Controller
{
    /**
     * Вывод платежей пользователя
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction($user, Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Payments")
            ->findBy(['user' => $user], ['date' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_rows'))
        );
        $back = Paginate::findPageModify(
            $user,
            $this->getDoctrine()
                ->getRepository("AppBundle:Users")
                ->findBy(array(), ['dateRegister' => 'DESC']),
            $this->container->getParameter('limit_rows')
        );
        return $this->render("@App/payments/list.html.twig", compact('list', 'user', 'back'));
    }

    /**
     * Внесение нового платежа пользователя
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newAction($user, Request $request)
    {
        $item = new Payments();
        $form = $this->createForm(Payment::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $item->setUser($user);
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Payments")
                    ->findBy(['user' => $user], ['date' => 'DESC']),
                $this->container->getParameter('limit_rows')
            );
            return $this->redirectToRoute('payments', compact('user', 'page'));
        }
        return $this->render('@App/payments/new.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование платежа
     * @param integer $id код показания
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction($id, Request $request)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Payments")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Payment::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $user = $item->getUser();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Payments")
                    ->findBy(['user' => $user], ['date' => 'DESC']),
                $this->container->getParameter('limit_rows')
            );
            return $this->redirectToRoute('payments', compact('user', 'page'));
        }
        return $this->render('@App/payments/edit.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление платежа
     * @param integer $id код платежа
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Payments")
            ->find($id);
        $user = $item->getUser();
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Payments")
            ->findBy(['user' => $user], ['date' => 'DESC']);
        $em = $this->getDoctrine()->getManager();
        $em->remove($item);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('payments', compact('user', 'page'));
    }
}