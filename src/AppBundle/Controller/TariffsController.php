<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Tariffs;
use AppBundle\Form\Tariff;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Extend\Utils\Paginate;

/**
 * Контроллер тарифов
 * @package AppBundle\Controller
 */
class TariffsController extends Controller
{
    /**
     * Вывод списка тарифов
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction(Request $request)
    {
        $actually = $this->getDoctrine()
            ->getManager()
            ->getRepository("AppBundle:Tariffs")
            ->getTariffsActual();
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Tariffs")
            ->getTariffsSortHistory();
        $paginator = $this->get('knp_paginator');
        $history = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render("@App/tariffs/list.html.twig", compact('actually', 'history'));
    }

    /**
     * Создание тарифа
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newAction(Request $request)
    {
        $item = new Tariffs();
        $form = $this->createForm(Tariff::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Tariffs")
                    ->getTariffsSortHistory(),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('tariffs', compact('page'));
        }
        return $this->render('@App/tariffs/new.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование тарифа
     * @param integer $id код тарифа
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction($id, Request $request)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Tariffs")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Tariff::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Tariffs")
                    ->getTariffsSortHistory(),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('tariffs', compact('page'));
        }
        return $this->render('@App/tariffs/edit.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление тарифа
     * @param integer $id код тарифа
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Tariffs")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Tariffs")
            ->getTariffsSortHistory();
        $em = $this->getDoctrine()->getManager();
        $em->remove($item);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('tariffs', compact('page'));
    }
}