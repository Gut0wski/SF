<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Measurements;
use AppBundle\Form\Measurement;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Extend\Utils\Paginate;

/**
 * Контроллер контрольных показаний
 * @package AppBundle\Controller
 */
class MeasurementsController extends Controller
{
    /**
     * Вывод расчетной ведомости текущего пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function calculateAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Measurements")
            ->getCalculate($this->getUser()->getId());
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_rows'))
        );
        return $this->render("@App/measurements/calculate.html.twig", compact('list', 'rows'));
    }

    /**
     * Вывод контрольных показаний пользователя
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction($user, Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Measurements")
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
        return $this->render("@App/measurements/list.html.twig", compact('list', 'user', 'back'));
    }

    /**
     * Внесение нового контрольного показания пользователю
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newAction($user, Request $request)
    {
        $item = new Measurements();
        $form = $this->createForm(Measurement::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $item->setUser($user);
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Measurements")
                    ->findBy(['user' => $user], ['date' => 'DESC']),
                $this->container->getParameter('limit_rows')
            );
            return $this->redirectToRoute('measurements', compact('user', 'page'));
        }
        return $this->render('@App/measurements/new.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование контрольного показания
     * @param integer $id код показания
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction($id, Request $request)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Measurements")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Measurement::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $user = $item->getUser();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Measurements")
                    ->findBy(['user' => $user], ['date' => 'DESC']),
                $this->container->getParameter('limit_rows')
            );
            return $this->redirectToRoute('measurements', compact('user', 'page'));
        }
        return $this->render('@App/measurements/edit.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление контрольного показания
     * @param integer $id код показания
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Measurements")
            ->find($id);
        $user = $item->getUser();
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Measurements")
            ->findBy(['user' => $user], ['date' => 'DESC']);
        $em = $this->getDoctrine()->getManager();
        $em->remove($item);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_rows')
        );
        return $this->redirectToRoute('measurements', compact('user', 'page'));
    }

    /**
     * Вывод расчетной ведомости выбранного пользователя
     * @param integer $user код пользователя
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function calculateUserAction($user, Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Measurements")
            ->getCalculate($user);
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
        return $this->render("@App/measurements/calculateUser.html.twig", compact('list', 'back', 'rows'));
    }
}