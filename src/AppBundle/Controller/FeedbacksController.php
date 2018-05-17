<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Feedbacks;
use AppBundle\Form\Complaint;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * Контроллер откликов на обсуждения
 * @package AppBundle\Controller
 */
class FeedbacksController extends Controller
{
    /**
     * Вывод жалоб пользователей
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function complaintsAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Feedbacks")
            ->findBy(['type' => '1'], ['date' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_rows'))
        );
        return $this->render("@App/feedbacks/complaints.html.twig", compact('list'));
    }

    /**
     * Новая жалоба
     * @param integer $message код сообщения
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newComplaintAction($message, Request $request)
    {
        $session = $request->getSession();
        $complain = new Feedbacks();
        $form = $this->createForm(Complaint::class, $complain);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $object_message = $this->getDoctrine()
                ->getRepository("AppBundle:Discussions")
                ->findOneById($message);
            $object_user = $this->getDoctrine()
                ->getRepository("AppBundle:Users")
                ->findOneById($this->getUser()->getId());
            $complain->setMessage($object_message);
            $complain->setType(1);
            $complain->setUser($object_user);
            $em = $this->getDoctrine()->getManager();
            $em->persist($complain);
            $em->flush();
            return $this->redirect($session->get('return_url'));
        }
        $session->set('return_url', $request->headers->get('referer'));
        return $this->render("@App/feedbacks/newComplaint.html.twig", [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Присвоение оценки сообщения
     * @param integer $user код пользователя
     * @param integer $message код сообщения
     * @param integer $type тип оценки (1 - положительная, 2 - отрицательная)
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function assessmentAction($user, $message, $type, Request $request)
    {
        $this->getDoctrine()
            ->getManager()
            ->getRepository("AppBundle:Blocks")
            ->getNewAssessment($user, $message, $type);
        return $this->redirect($request->headers->get('referer'));
    }
}